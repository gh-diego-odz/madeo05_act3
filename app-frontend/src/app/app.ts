import { Component, inject, OnInit, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { firstValueFrom } from 'rxjs';

interface Subject {
  objectId: string;
  name: string;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [FormsModule],
  template: `
    <div class="min-h-screen bg-gray-50 p-4 sm:p-8 flex flex-col items-center justify-center font-sans">
      <div class="max-w-md w-full bg-white rounded-xl shadow-sm border border-gray-100 p-6">
        <header class="mb-6 text-center border-b border-gray-100 pb-4">
          <h1 class="text-xl font-bold text-blue-600 leading-tight">
            Actividad Grupal
          </h1>
          <p class="text-sm text-gray-500 mt-1">
            Despliegue de MEAN multicapa mediante Terraform
          </p>
        </header>

        <div class="flex gap-2 mb-6">
          <input
            type="text"
            [(ngModel)]="newSubjectName"
            placeholder="Nueva materia..."
            class="flex-1 px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
          />
          <button
            (click)="addSubject()"
            class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 active:transform active:scale-95 transition-all"
          >
            Añadir
          </button>
        </div>

        <div class="relative">
          <div class="h-[300px] overflow-y-auto pr-1 custom-scrollbar">
            <ul class="divide-y divide-gray-100">
              @for (subject of subjects(); track subject.objectId) {
                <li
                  class="py-3 flex items-center justify-between group hover:bg-gray-50 transition-colors px-2 rounded-md"
                >
                  <div class="flex flex-col min-w-0 mr-4">
                    <span class="text-sm font-medium text-gray-800 truncate">
                      {{ subject.name }}
                    </span>
                    <span class="text-[10px] text-gray-400 font-mono truncate">
                      ID: {{ subject.objectId }}
                    </span>
                  </div>
                  <button
                    (click)="deleteSubject(subject.objectId)"
                    class="text-gray-400 hover:text-red-500 p-1 transition-colors"
                    title="Eliminar"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </li>
              } @empty {
                <li class="py-12 text-center">
                  <p class="text-sm text-gray-400 italic">No hay materias registradas</p>
                </li>
              }
            </ul>
          </div>
        </div>
        <footer class="mt-6 pt-4 border-t border-gray-100 text-center">
          <div class="mb-4 p-3 bg-blue-50 rounded-lg border border-blue-100">
            <p class="text-[11px] text-blue-700 leading-relaxed">
              Aplicación de ejemplo con una lista de materias para demostrar la conexión entre todas las capas de la arquitectura creada con Terraform.
            </p>
          </div>
          <p class="text-xs font-medium text-gray-400 uppercase tracking-wider">
            Universidad Internacional de La Rioja (UNIR)
          </p>
        </footer>
      </div>
    </div>
  `
})
export class App implements OnInit {
  private http = inject(HttpClient);
  private apiUrl = '/api/subject';

  subjects = signal<Subject[]>([]);
  newSubjectName = '';

  ngOnInit() {
    this.loadSubjects();
  }

  async loadSubjects() {
    try {
      const data = await firstValueFrom(this.http.get<Subject[]>(this.apiUrl));
      this.subjects.set(data);
    } catch (err) {
      console.error('Error al cargar materias:', err);
    }
  }

  async addSubject() {
    if (!this.newSubjectName.trim()) return;

    try {
      await firstValueFrom(this.http.post<Subject>(this.apiUrl, { name: this.newSubjectName }));
      this.newSubjectName = '';
      await this.loadSubjects();
    } catch (err) {
      console.error('Error al agregar materia:', err);
    }
  }

  async deleteSubject(id: string) {
    try {
      await firstValueFrom(this.http.delete(`${this.apiUrl}/${id}`));
      await this.loadSubjects();
    } catch (err) {
      console.error('Error al eliminar materia:', err);
    }
  }
}
